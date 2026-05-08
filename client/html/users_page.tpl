<div class='user-list'>
    <ul><!--
        --><% for (let user of ctx.response.results) { %><!--
            --><li>
                <div class='wrapper'>
                    <% if (ctx.canViewUsers) { %>
                        <a class='image' href='<%- ctx.formatClientLink('user', user.name) %>'>
                    <% } %>
                        <%= ctx.makeThumbnail(user.avatarUrl) %>
                    <% if (ctx.canViewUsers) { %>
                        </a>
                    <% } %>
                    <div class='details'>
                        <% if (ctx.canViewUsers) { %>
                            <a href='<%- ctx.formatClientLink('user', user.name) %>'>
                        <% } %>
                            <%- user.name %>
                        <% if (ctx.canViewUsers) { %>
                            </a>
                        <% } %>
                        <br/>
                        <%= ctx.t('usersPage.registered') %> <%= ctx.makeRelativeTime(user.creationTime) %><br/>
                        <%= ctx.t('usersPage.lastSeen') %> <%= ctx.makeRelativeTime(user.lastLoginTime) %>
                    </div>
                </div>
            </li><!--
        --><% } %><!--
        --><%= ctx.makeFlexboxAlign() %><!--
    --></ul>
</div>
