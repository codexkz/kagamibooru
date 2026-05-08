<div class='content-wrapper tag-categories'>
    <form>
        <h1><%= ctx.t('tagCategories.title') %></h1>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th class='name'><%= ctx.t('tagCategories.name') %></th>
                        <th class='color'><%= ctx.t('tagCategories.color') %></th>
                        <th class='order'><%= ctx.t('tagCategories.order') %></th>
                        <th class='usages'><%= ctx.t('tagCategories.usages') %></th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>

        <% if (ctx.canCreate) { %>
            <p><a href class='add'><%= ctx.t('tagCategories.add') %></a></p>
        <% } %>

        <div class='messages'></div>

        <% if (ctx.canCreate || ctx.canEditName || ctx.canEditColor || ctx.canEditOrder || ctx.canDelete) { %>
            <div class='buttons'>
                <input type='submit' class='save' value='<%= ctx.t("tagCategories.save") %>'>
            </div>
        <% } %>
    </form>
</div>
