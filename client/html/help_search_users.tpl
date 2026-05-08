<p><strong><%= ctx.t('help.search.anonymousTokens') %></strong></p>

<p><%= ctx.t('help.search.sameAs').replace('{token}', '<code>name</code>') %></p>

<p><strong><%= ctx.t('help.search.namedTokens') %></strong></p>

<table>
    <tbody>
        <tr>
            <td><code>name</code></td>
            <td><%= ctx.t('help.searchUsers.name') %></td>
        </tr>
        <tr>
            <td><code>creation-date</code></td>
            <td><%= ctx.t('help.searchUsers.creationDate') %></td>
        </tr>
        <tr>
            <td><code>creation-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>creation-date</code>') %></td>
        </tr>
        <tr>
            <td><code>last-login-date</code>
            <td><%= ctx.t('help.searchUsers.lastLoginDate') %></td>
        </tr>
        <tr>
            <td><code>last-login-time</code>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>last-login-date</code>') %></td>
        </tr>
        <tr>
            <td><code>login-date</code>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>last-login-date</code>') %></td>
        </tr>
        <tr>
            <td><code>login-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>last-login-date</code>') %></td>
        </tr>
    </tbody>
</table>

<p><strong><%= ctx.t('help.search.sortTokens') %></strong></p>

<table>
    <tbody>
        <tr>
            <td><code>random</code></td>
            <td><%= ctx.t('help.searchUsers.sortRandom') %></td>
        </tr>
        <tr>
            <td><code>name</code></td>
            <td><%= ctx.t('help.searchUsers.sortName') %></td>
        </tr>
        <tr>
            <td><code>creation-date</code></td>
            <td><%= ctx.t('help.searchUsers.sortCreationDate') %></td>
        </tr>
        <tr>
            <td><code>creation-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>creation-date</code>') %></td>
        </tr>
        <tr>
            <td><code>last-login-date</code></td>
            <td><%= ctx.t('help.searchUsers.sortLastLoginDate') %></td>
        </tr>
        <tr>
            <td><code>last-login-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>last-login-date</code>') %></td>
        </tr>
        <tr>
            <td><code>login-date</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>last-login-date</code>') %></td>
        </tr>
        <tr>
            <td><code>login-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>last-login-date</code>') %></td>
        </tr>
    </tbody>
</table>

<p><strong><%= ctx.t('help.search.specialTokens') %></strong></p>

<p><%= ctx.t('help.search.none') %></p>
