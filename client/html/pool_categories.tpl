<div class='content-wrapper pool-categories'>
    <form>
        <h1><%= ctx.t('poolCategories.title') %></h1>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th class='name'><%= ctx.t('poolCategories.name') %></th>
                        <th class='color'><%= ctx.t('poolCategories.color') %></th>
                        <th class='usages'><%= ctx.t('poolCategories.usages') %></th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>

        <% if (ctx.canCreate) { %>
            <p><a href class='add'><%= ctx.t('poolCategories.add') %></a></p>
        <% } %>

        <div class='messages'></div>

        <% if (ctx.canCreate || ctx.canEditName || ctx.canEditColor || ctx.canDelete) { %>
            <div class='buttons'>
                <input type='submit' class='save' value='<%= ctx.t("poolCategories.save") %>'>
            </div>
        <% } %>
    </form>
</div>
