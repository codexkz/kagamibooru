<div class='pool-merge'>
    <form>
        <ul class='input'>
            <li class='target'>
                <%= ctx.makeTextInput({name: 'target-pool', required: true, text: ctx.t('poolMerge.targetPool'), pattern: ctx.poolNamePattern}) %>
            </li>

            <li>
                <p><%= ctx.t('poolMerge.hint') %></p>

                <%= ctx.makeCheckbox({required: true, text: ctx.t('poolMerge.confirm')}) %>
            </li>
        </ul>

        <div class='messages'></div>

        <div class='buttons'>
            <input type='submit' value='<%= ctx.t("poolMerge.submit") %>'/>
        </div>
    </form>
</div>
