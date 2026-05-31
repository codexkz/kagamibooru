<div class='fav-group-picker-overlay'>
    <div class='fav-group-picker'>
        <h2><%= ctx.t('favGroup.pickerTitle') %></h2>

        <form class='create-row'>
            <input type='text' class='new-group-name' placeholder='<%= ctx.t("favGroup.name") %>'>
            <button type='submit' class='create-group'><%= ctx.t('favGroup.create') %></button>
        </form>

        <div class='messages'></div>

        <ul class='fav-group-list'>
            <% for (let group of ctx.groups) { %>
                <li data-group-id='<%= group.id %>'>
                    <label>
                        <input type='checkbox' <%= ctx.memberOf.has(group.id) ? "checked" : "" %>>
                        <span class='info'>
                            <span class='line'>
                                <span class='name'><%- group.name %></span><!--
                                --><% if (group.isDefault) { %><span class='default-badge'><%= ctx.t('favGroup.defaultBadge') %></span><% } %><!--
                                --><span class='count'>(<%- group.postCount %>)</span>
                            </span>
                        </span>
                    </label>
                    <span class='row-actions'>
                        <a href class='rename' title='<%= ctx.t("favGroup.rename") %>'><i class='fa fa-pencil'></i></a><!--
                        --><% if (!group.isDefault) { %><a href class='delete' title='<%= ctx.t("favGroup.delete") %>'><i class='fa fa-trash-o'></i></a><% } %>
                    </span>
                </li>
            <% } %>
        </ul>

        <div class='buttons'>
            <button class='close'><%= ctx.t('favGroup.close') %></button>
        </div>
    </div>
</div>
