import asyncio

import requests
from prefect import flow, get_run_logger, task
from prefect.blocks.system import Secret
from prefect_slack import SlackCredentials
from prefect_slack.messages import send_chat_message


# Extraction Task pulls 5-day, 3-hour forecast for the provided City
@task(retries=2, retry_delay_seconds=5)
def pull_forecast(city, api_key):
    base_url = "http://api.openweathermap.org/data/2.5/forecast?"
    url = base_url + "appid=" + api_key + "&q=" + city
    r = requests.get(url)
    r.raise_for_status()
    r.json()


@task(tags=["example", "api", "weather"])
def is_raining_this_week(data):
    rain = [
        forecast["rain"].get("3h", 0) for forecast in data["list"] if "rain" in forecast
    ]
    bool(sum([s >= 1 for s in rain]) >= 1)


# Notification Task sends message to Cloud once authenticated with a webhook
rain_notification, dry_notification = [
    """🎵 Raindrops keep fallin' on my head, and just like the guy whose feet are too big for his bed,
 I'm never gonna stop the rain by complainin' 🌧️☂️ """,
    "🎤 It's gonna be a bright (bright) Bright (bright) sunshiny day! 🎵🌻😎",
]


@flow
async def rain_flow(city: str = "Birmingham"):
    logger = get_run_logger()

    api_key = (await Secret.load("openweathermap-api-key")).get()
    slack_credentials = await SlackCredentials.load("allthedatathings")

    forecast = pull_forecast(city=city, api_key=api_key)
    rain = is_raining_this_week(forecast)

    message = rain_notification if rain else dry_notification

    logger.info(f"Sending slack message: {message}")

    await send_chat_message(
        slack_credentials=slack_credentials, channel="#sandbox", text=message
    )


if __name__ == "__main__":
    asyncio.run(rain_flow(city="Texas"))
