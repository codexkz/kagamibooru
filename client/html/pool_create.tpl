<div class='content-wrapper pool-create'>
    <form>
        <ul class='input'>
            <li class='names'>
                <%= ctx.makeTextInput({
                    text: ctx.t('poolCreate.names'),
                    value: '',
                    required: true,
                }) %>
            </li>
            <li class='category'>
                <%= ctx.makeSelect({
                    text: ctx.t('poolCreate.category'),
                    keyValues: ctx.categories,
                    selectedKey: 'default',
                    required: true,
                }) %>
            </li>
            <li class='description'>
                <%= ctx.makeTextarea({
                    text: ctx.t('poolCreate.description'),
                    value: '',
                }) %>
            </li>
            <li class='posts'>
                <%= ctx.makeTextInput({
                    text: ctx.t('poolCreate.posts'),
                    value: '',
                    placeholder: ctx.t('poolCreate.postsPlaceholder'),
                }) %>
            </li>
        </ul>

        <% if (ctx.canCreate) { %>
            <div class='messages'></div>

            <div class='buttons'>
                <input type='submit' class='save' value='<%= ctx.t("poolCreate.submit") %>'>
            </div>
        <% } %>
    </form>
</div>
