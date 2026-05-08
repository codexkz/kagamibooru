<div class='post-merge'>
    <form>
        <ul class='input'>
            <li class='post-mirror'>
                <div class='left-post-container'></div>
                <div class='right-post-container'></div>
            </li>

            <li>
                <p><%= ctx.t('postMerge.hint') %></p>

                <%= ctx.makeCheckbox({required: true, text: ctx.t('postMerge.confirm')}) %>
            </li>
        </ul>

        <div class='messages'></div>

        <div class='buttons'>
            <input type='submit' value='<%= ctx.t("postMerge.submit") %>'/>
        </div>
    </form>
</div>
