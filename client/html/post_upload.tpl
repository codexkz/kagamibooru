<div id='post-upload'>
    <form>
        <div class='dropper-container'></div>

        <div class='control-strip'>
            <input type='submit' value='<%= ctx.t("postUpload.uploadAll") %>' class='submit'/>

            <span class='skip-duplicates'>
                <%= ctx.makeCheckbox({
                    text: ctx.t('postUpload.skipDuplicate'),
                    name: 'skip-duplicates',
                    checked: false,
                }) %>
            </span>

            <span class='always-upload-similar'>
                <%= ctx.makeCheckbox({
                    text: ctx.t('postUpload.forceUpload'),
                    name: 'always-upload-similar',
                    checked: false,
                }) %>
            </span>

            <span class='pause-remain-on-error'>
                <%= ctx.makeCheckbox({
                    text: ctx.t('postUpload.pauseOnError'),
                    name: 'pause-remain-on-error',
                    checked: true,
                }) %>
            </span>

            <input type='button' value='<%= ctx.t("postUpload.cancel") %>' class='cancel'/>
        </div>

        <div class='messages'></div>

        <ul class='uploadables-container'></ul>
    </form>
</div>
