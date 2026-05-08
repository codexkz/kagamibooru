<div class='pool-delete'>
    <form>
        <p>This pool has <a href='<%- ctx.formatClientLink('posts', {query: 'pool:' + ctx.pool.id}) %>'><%- ctx.pool.postCount %> <%= ctx.t('poolSummary.posts') %></a>.</p>

        <ul class='input'>
            <li>
                <%= ctx.makeCheckbox({
                    name: 'confirm-deletion',
                    text: ctx.t('poolDelete.confirm'),
                    required: true,
                }) %>
            </li>
        </ul>

        <div class='messages'></div>

        <div class='buttons'>
            <input type='submit' value='<%= ctx.t("poolDelete.submit") %>'/>
        </div>
    </form>
</div>
