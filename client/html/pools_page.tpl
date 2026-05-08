<div class='pool-list table-wrap'>
    <% if (ctx.response.results.length) { %>
        <table>
            <thead>
                <th class='names'>
                    <% if (ctx.parameters.query == 'sort:name' || !ctx.parameters.query) { %>
                        <a href='<%- ctx.formatClientLink('pools', {query: '-sort:name'}) %>'><%- ctx.t('poolsPage.poolNames') %></a>
                    <% } else { %>
                        <a href='<%- ctx.formatClientLink('pools', {query: 'sort:name'}) %>'><%- ctx.t('poolsPage.poolNames') %></a>
                    <% } %>
                </th>
                <th class='post-count'>
                     <% if (ctx.parameters.query == 'sort:post-count') { %>
                        <a href='<%- ctx.formatClientLink('pools', {query: '-sort:post-count'}) %>'><%- ctx.t('poolsPage.postCount') %></a>
                     <% } else { %>
                        <a href='<%- ctx.formatClientLink('pools', {query: 'sort:post-count'}) %>'><%- ctx.t('poolsPage.postCount') %></a>
                     <% } %>
                     </th>
                <th class='creation-time'>
                    <% if (ctx.parameters.query == 'sort:creation-time') { %>
                        <a href='<%- ctx.formatClientLink('pools', {query: '-sort:creation-time'}) %>'><%- ctx.t('poolsPage.createdOn') %></a>
                    <% } else { %>
                        <a href='<%- ctx.formatClientLink('pools', {query: 'sort:creation-time'}) %>'><%- ctx.t('poolsPage.createdOn') %></a>
                    <% } %>
                </th>
            </thead>
            <tbody>
                <% for (let pool of ctx.response.results) { %>
                    <tr>
                        <td class='names'>
                            <ul>
                                <% for (let name of pool.names) { %>
                                    <li><%= ctx.makePoolLink(pool.id, false, false, pool, name) %></li>
                                <% } %>
                            </ul>
                        </td>
                        <td class='post-count'>
                            <a href='<%- ctx.formatClientLink('posts', {query: 'pool:' + pool.id}) %>'><%- pool.postCount %></a>
                        </td>
                        <td class='creation-time'>
                            <%= ctx.makeRelativeTime(pool.creationTime) %>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</div>
