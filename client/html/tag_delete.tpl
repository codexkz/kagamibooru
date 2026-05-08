<div class='tag-delete'>
    <form>
        <p>This tag has <a href='<%- ctx.formatClientLink('posts', {query: ctx.escapeTagName(ctx.tag.names[0])}) %>'><%- ctx.tag.postCount %> <%= ctx.t('tagSummary.usages') %></a>.</p>

        <ul class='input'>
            <li>
                <%= ctx.makeCheckbox({
                    name: 'confirm-deletion',
                    text: ctx.t('tagDelete.confirm'),
                    required: true,
                }) %>
            </li>
        </ul>

        <div class='messages'></div>

        <div class='buttons'>
            <input type='submit' value='<%= ctx.t("tagDelete.submit") %>'/>
        </div>
    </form>
</div>
