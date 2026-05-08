<div class='tag-list table-wrap'>
    <% if (ctx.response.results.length) { %>
        <table>
            <thead>
                <th class='names'>
                    <% if (ctx.parameters.query == 'sort:name' || !ctx.parameters.query) { %>
                        <a href='<%- ctx.formatClientLink('tags', {query: '-sort:name'}) %>'><%- ctx.t('tagsPage.tagNames') %></a>
                    <% } else { %>
                        <a href='<%- ctx.formatClientLink('tags', {query: 'sort:name'}) %>'><%- ctx.t('tagsPage.tagNames') %></a>
                    <% } %>
                </th>
                <th class='implications'>
                    <% if (ctx.parameters.query == 'sort:implication-count') { %>
                        <a href='<%- ctx.formatClientLink('tags', {query: '-sort:implication-count'}) %>'><%- ctx.t('tagsPage.implications') %></a>
                    <% } else { %>
                        <a href='<%- ctx.formatClientLink('tags', {query: 'sort:implication-count'}) %>'><%- ctx.t('tagsPage.implications') %></a>
                    <% } %>
                </th>
                <th class='suggestions'>
                    <% if (ctx.parameters.query == 'sort:suggestion-count') { %>
                        <a href='<%- ctx.formatClientLink('tags', {query: '-sort:suggestion-count'}) %>'><%- ctx.t('tagsPage.suggestions') %></a>
                    <% } else { %>
                        <a href='<%- ctx.formatClientLink('tags', {query: 'sort:suggestion-count'}) %>'><%- ctx.t('tagsPage.suggestions') %></a>
                    <% } %>
                </th>
                <th class='usages'>
                    <% if (ctx.parameters.query == 'sort:usages') { %>
                        <a href='<%- ctx.formatClientLink('tags', {query: '-sort:usages'}) %>'><%- ctx.t('tagsPage.usages') %></a>
                    <% } else { %>
                        <a href='<%- ctx.formatClientLink('tags', {query: 'sort:usages'}) %>'><%- ctx.t('tagsPage.usages') %></a>
                    <% } %>
                </th>
                <th class='creation-time'>
                    <% if (ctx.parameters.query == 'sort:creation-time') { %>
                        <a href='<%- ctx.formatClientLink('tags', {query: '-sort:creation-time'}) %>'><%- ctx.t('tagsPage.createdOn') %></a>
                    <% } else { %>
                        <a href='<%- ctx.formatClientLink('tags', {query: 'sort:creation-time'}) %>'><%- ctx.t('tagsPage.createdOn') %></a>
                    <% } %>
                </th>
            </thead>
            <tbody>
                <% for (let tag of ctx.response.results) { %>
                    <tr>
                        <td class='names'>
                            <ul>
                                <% for (let name of tag.names) { %>
                                    <li><%= ctx.makeTagLink(name, false, false, tag) %></li>
                                <% } %>
                            </ul>
                        </td>
                        <td class='implications'>
                            <% if (tag.implications.length) { %>
                                <ul>
                                    <% for (let relation of tag.implications) { %>
                                        <li><%= ctx.makeTagLink(relation.names[0], false, false, relation) %></li>
                                    <% } %>
                                </ul>
                            <% } else { %>
                                -
                            <% } %>
                        </td>
                        <td class='suggestions'>
                            <% if (tag.suggestions.length) { %>
                                <ul>
                                    <% for (let relation of tag.suggestions) { %>
                                        <li><%= ctx.makeTagLink(relation.names[0], false, false, relation) %></li>
                                    <% } %>
                                </ul>
                            <% } else { %>
                                -
                            <% } %>
                        </td>
                        <td class='usages'>
                            <%- tag.postCount %>
                        </td>
                        <td class='creation-time'>
                            <%= ctx.makeRelativeTime(tag.creationTime) %>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</div>
