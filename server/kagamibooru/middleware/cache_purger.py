from kagamibooru import rest
from kagamibooru.func import cache
from kagamibooru.rest import middleware


@middleware.pre_hook
def process_request(ctx: rest.Context) -> None:
    if ctx.method != "GET":
        cache.purge()
