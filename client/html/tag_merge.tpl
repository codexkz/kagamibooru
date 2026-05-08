<div class='tag-merge'>
    <form>
        <ul class='input'>
            <li class='target'>
                <%= ctx.makeTextInput({name: 'target-tag', required: true, text: ctx.t('tagMerge.targetTag'), pattern: ctx.tagNamePattern}) %>
            </li>

            <li>
                <p><%= ctx.t('tagMerge.hint') %></p>

                <%= ctx.makeCheckbox({name: 'alias', text: ctx.t('tagMerge.alias')}) %>

                <%= ctx.makeCheckbox({required: true, text: ctx.t('tagMerge.confirm')}) %>
            </li>
        </ul>

        <div class='messages'></div>

        <div class='buttons'>
            <input type='submit' value='<%= ctx.t("tagMerge.submit") %>'/>
        </div>
    </form>
</div>
