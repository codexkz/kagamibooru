<p><strong><%= ctx.t('help.search.anonymousTokens') %></strong></p>

<p><%= ctx.t('help.search.sameAs').replace('{token}', '<code>name</code>') %></p>

<p><strong><%= ctx.t('help.search.namedTokens') %></strong></p>

<table>
    <tbody>
        <tr>
            <td><code>name</code></td>
            <td><%= ctx.t('help.searchPools.name') %></td>
        </tr>
        <tr>
            <td><code>category</code></td>
            <td><%= ctx.t('help.searchPools.category') %></td>
        </tr>
        <tr>
            <td><code>creation-date</code></td>
            <td><%= ctx.t('help.searchPools.creationDate') %></td>
        </tr>
        <tr>
            <td><code>creation-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>creation-date</code>') %></td>
        </tr>
        <tr>
            <td><code>last-edit-date</code></td>
            <td><%= ctx.t('help.searchPools.lastEditDate') %></td>
        </tr>
        <tr>
            <td><code>last-edit-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>last-edit-date</code>') %></td>
        </tr>
        <tr>
            <td><code>edit-date</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>last-edit-date</code>') %></td>
        </tr>
        <tr>
            <td><code>edit-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>last-edit-date</code>') %></td>
        </tr>
        <tr>
            <td><code>post-count</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>usages</code>') %></td>
        </tr>
    </tbody>
</table>

<p><strong><%= ctx.t('help.search.sortTokens') %></strong></p>

<table>
    <tbody>
        <tr>
            <td><code>random</code></td>
            <td><%= ctx.t('help.searchPools.sortRandom') %></td>
        </tr>
        <tr>
            <td><code>name</code></td>
            <td><%= ctx.t('help.searchPools.sortName') %></td>
        </tr>
        <tr>
            <td><code>category</code></td>
            <td><%= ctx.t('help.searchPools.sortCategory') %></td>
        </tr>
        <tr>
            <td><code>creation-date</code></td>
            <td><%= ctx.t('help.searchPools.sortCreationDate') %></td>
        </tr>
        <tr>
            <td><code>creation-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>creation-date</code>') %></td>
        </tr>
        <tr>
            <td><code>last-edit-date</code></td>
            <td><%= ctx.t('help.searchPools.sortLastEditDate') %></td>
        </tr>
        <tr>
            <td><code>last-edit-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>creation-time</code>') %></td>
        </tr>
        <tr>
            <td><code>edit-date</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>creation-time</code>') %></td>
        </tr>
        <tr>
            <td><code>edit-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>creation-time</code>') %></td>
        </tr>
        <tr>
            <td><code>post-count</code></td>
            <td><%= ctx.t('help.searchPools.sortPostCount') %></td>
        </tr>
    </tbody>
</table>

<p><strong><%= ctx.t('help.search.specialTokens') %></strong></p>

<p><%= ctx.t('help.search.none') %></p>
