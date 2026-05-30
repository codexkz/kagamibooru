<tr data-scan-id='<%= ctx.scan.id %>' class='scan-row status-<%- ctx.scan.status %>'>
    <td class='id'>#<%- ctx.scan.id %></td>
    <td class='created'><%= ctx.makeRelativeTime(ctx.scan.creationTime) %></td>
    <td class='status'><%- ctx.t('similarity.status.' + ctx.scan.status) %></td>
    <td class='progress'>
        <span class='counts'><%- ctx.scan.processedCount %>/<%- ctx.scan.totalCount %></span>
        <% if (ctx.scan.status === 'running') { %>
            <span class='bar'><span class='fill' style='width: <%- ctx.scan.progress %>%'></span></span>
            <span class='pct'><%- ctx.scan.progress %>%</span>
        <% } %>
    </td>
    <td class='groups'><%- ctx.scan.status === 'done' ? ctx.scan.groupCount : '—' %></td>
    <td class='actions'>
        <% if (ctx.scan.status === 'done') { %>
            <a class='view' href='<%= ctx.formatClientLink('similarity-scan', ctx.scan.id) %>'><%= ctx.t('similarity.view') %></a>
        <% } %>
        <% if (ctx.canDelete) { %>
            <a class='delete' href>✕</a>
        <% } %>
    </td>
</tr>
