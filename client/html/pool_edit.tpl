<div class='content-wrapper pool-edit'>
    <form>
        <ul class='input'>
            <li class='names'>
                <% if (ctx.canEditNames) { %>
                    <%= ctx.makeTextInput({
                        text: ctx.t('poolEdit.names'),
                        value: ctx.pool.names.join(' '),
                        required: true,
                    }) %>
                <% } %>
            </li>
            <li class='category'>
                <% if (ctx.canEditCategory) { %>
                    <%= ctx.makeSelect({
                        text: ctx.t('poolEdit.category'),
                        keyValues: ctx.categories,
                        selectedKey: ctx.pool.category,
                        required: true,
                    }) %>
                <% } %>
            </li>
            <li class='description'>
                <% if (ctx.canEditDescription) { %>
                    <%= ctx.makeTextarea({
                        text: ctx.t('poolEdit.description'),
                        value: ctx.pool.description,
                    }) %>
                <% } %>
            </li>
            <li class='posts'>
                <% if (ctx.canEditPosts) { %>
                    <%= ctx.makeTextInput({
                        text: ctx.t('poolEdit.posts'),
                        placeholder: ctx.t('poolEdit.postsPlaceholder'),
                        value: ctx.pool.posts.map(post => post.id).join(' ')
                    }) %>
                <% } %>
            </li>
        </ul>

        <% if (ctx.canEditAnything) { %>
            <div class='messages'></div>

            <div class='buttons'>
                <input type='submit' class='save' value='<%= ctx.t("poolEdit.save") %>'>
            </div>
        <% } %>
    </form>
</div>
