<p><strong><%= ctx.t('help.search.anonymousTokens') %></strong></p>

<p><%= ctx.t('help.search.sameAs').replace('{token}', '<code>name</code>') %></p>

<p><strong><%= ctx.t('help.search.namedTokens') %></strong></p>

<table>
    <tbody>
        <tr>
            <td><code>name</code></td>
            <td><%= ctx.t('help.searchTags.name') %></td>
        </tr>
        <tr>
            <td><code>category</code></td>
            <td><%= ctx.t('help.searchTags.category') %></td>
        </tr>
        <tr>
            <td><code>creation-date</code></td>
            <td><%= ctx.t('help.searchTags.creationDate') %></td>
        </tr>
        <tr>
            <td><code>creation-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>creation-date</code>') %></td>
        </tr>
        <tr>
            <td><code>last-edit-date</code></td>
            <td><%= ctx.t('help.searchTags.lastEditDate') %></td>
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
            <td><code>usages</code></td>
            <td><%= ctx.t('help.searchTags.usages') %></td>
        </tr>
        <tr>
            <td><code>usage-count</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>usages</code>') %></td>
        </tr>
        <tr>
            <td><code>post-count</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>usages</code>') %></td>
        </tr>
        <tr>
            <td><code>suggestion-count</code></td>
            <td><%= ctx.t('help.searchTags.suggestionCount') %></td>
        </tr>
        <tr>
            <td><code>implication-count</code></td>
            <td><%= ctx.t('help.searchTags.implicationCount') %></td>
        </tr>
    </tbody>
</table>

<p><strong><%= ctx.t('help.search.sortTokens') %></strong></p>

<table>
    <tbody>
        <tr>
            <td><code>random</code></td>
            <td><%= ctx.t('help.searchTags.sortRandom') %></td>
        </tr>
        <tr>
            <td><code>name</code></td>
            <td><%= ctx.t('help.searchTags.sortName') %></td>
        </tr>
        <tr>
            <td><code>category</code></td>
            <td><%= ctx.t('help.searchTags.sortCategory') %></td>
        </tr>
        <tr>
            <td><code>creation-date</code></td>
            <td><%= ctx.t('help.searchTags.sortCreationDate') %></td>
        </tr>
        <tr>
            <td><code>creation-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>creation-date</code>') %></td>
        </tr>
        <tr>
            <td><code>last-edit-date</code></td>
            <td><%= ctx.t('help.searchTags.sortLastEditDate') %></td>
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
            <td><code>usages</code></td>
            <td><%= ctx.t('help.searchTags.sortUsages') %></td>
        </tr>
        <tr>
            <td><code>usage-count</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>usages</code>') %></td>
        </tr>
        <tr>
            <td><code>post-count</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>usages</code>') %></td>
        </tr>
        <tr>
            <td><code>suggestion-count</code></td>
            <td><%= ctx.t('help.searchTags.sortSuggestionCount') %></td>
        </tr>
        <tr>
            <td><code>implication-count</code></td>
            <td><%= ctx.t('help.searchTags.sortImplicationCount') %></td>
        </tr>
    </tbody>
</table>

<p><strong><%= ctx.t('help.search.specialTokens') %></strong></p>

<p><%= ctx.t('help.search.none') %></p>
