<div id='admin-users'>
    <div class='messages'></div>

    <% if (ctx.canCreate) { %>
    <form id='create-user-form'>
        <input class='anticomplete' type='text' name='fakeuser'/>
        <input class='anticomplete' type='password' name='fakepass'/>
        <ul class='input'>
            <li>
                <%= ctx.makeTextInput({
                    text: ctx.t('adminUsers.userName'),
                    name: 'name',
                    required: true,
                    pattern: ctx.userNamePattern,
                }) %>
            </li>
            <li>
                <%= ctx.makePasswordInput({
                    text: ctx.t('adminUsers.password'),
                    name: 'password',
                    required: true,
                    pattern: ctx.passwordPattern,
                }) %>
            </li>
            <li>
                <%= ctx.makeEmailInput({
                    text: ctx.t('adminUsers.email'),
                    name: 'email',
                }) %>
            </li>
            <li>
                <%= ctx.makeSelect({
                    text: ctx.t('adminUsers.rank'),
                    name: 'rank',
                    keyValues: ctx.ranks,
                    selectedKey: 'regular',
                }) %>
            </li>
        </ul>
        <div class='buttons'>
            <input type='submit' value='<%= ctx.t("adminUsers.create") %>'/>
        </div>
    </form>
    <% } %>

    <table class='admin-users-table'>
        <thead>
            <tr>
                <th><%= ctx.t('adminUsers.userName') %></th>
                <th><%= ctx.t('adminUsers.rank') %></th>
                <th><%= ctx.t('adminUsers.email') %></th>
                <th><%= ctx.t('adminUsers.created') %></th>
                <th><%= ctx.t('adminUsers.lastLogin') %></th>
                <th><%= ctx.t('adminUsers.actions') %></th>
            </tr>
        </thead>
        <tbody>
            <% for (let user of ctx.users) { %>
            <tr data-user='<%= user.name %>'>
                <td>
                    <a href='<%- ctx.formatClientLink('user', user.name) %>'><%= user.name %></a>
                </td>
                <td>
                    <% if (ctx.canEdit) { %>
                    <select class='rank-select' data-user='<%= user.name %>'>
                        <% for (let [key, name] of Object.entries(ctx.ranks)) { %>
                            <option value='<%= key %>' <%= key === user.rank ? "selected" : "" %>><%= name %></option>
                        <% } %>
                    </select>
                    <% } else { %>
                        <%= ctx.ranks[user.rank] || user.rank %>
                    <% } %>
                </td>
                <td><%= user.email || '-' %></td>
                <td><%= ctx.makeRelativeTime(user.creationTime) %></td>
                <td><%= ctx.makeRelativeTime(user.lastLoginTime) %></td>
                <td>
                    <% if (ctx.canEdit) { %>
                        <a href='#' class='btn-reset-password' data-user='<%= user.name %>'><%= ctx.t('adminUsers.resetPassword') %></a>
                    <% } %>
                    <% if (ctx.canDelete && user.name !== ctx.currentUser) { %>
                        <a href='#' class='btn-delete-user' data-user='<%= user.name %>'><%= ctx.t('adminUsers.delete') %></a>
                    <% } %>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>
