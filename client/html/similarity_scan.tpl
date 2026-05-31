<div class='content-wrapper similarity-scan-result'>
    <p class='back'>
        <a href='<%= ctx.formatClientLink('similarity-scans') %>'>&lang; <%= ctx.t('similarity.back') %></a>
    </p>
    <h1>
        <%= ctx.t('similarity.scanHeading').replace('{id}', ctx.scan.id) %>
    </h1>
    <p class='summary'>
        <%= ctx.t('similarity.summary')
            .replace('{groups}', ctx.scan.groupCount)
            .replace('{threshold}', ctx.scan.threshold) %>
    </p>
    <% if (ctx.scan.kind === 'single' && ctx.scan.queryLabel) { %>
        <p class='query-label'>
            <%= ctx.t('similarity.queryLabel').replace('{label}', ctx.scan.queryLabel) %>
        </p>
    <% } %>

    <div class='messages'></div>

    <% if (!ctx.groups.length) { %>
        <p class='no-results'><%= ctx.t('similarity.noGroups') %></p>
    <% } %>

    <div class='groups'>
        <% for (let [index, group] of ctx.groups.entries()) { %>
            <div class='group' data-group-id='<%= group.id %>'>
                <h2><%= ctx.t('similarity.group').replace('{n}', ctx.offset + index + 1) %>
                    <span class='count'>(<%- group.members.length %>)</span>
                </h2>
                <ul class='thumbs'>
                    <% for (let member of group.members) { %>
                        <li>
                            <a class='thumbnail-wrapper'
                               target='_blank'
                               href='<%= ctx.formatClientLink('post', member.postId) %>'>
                                <% if (member.post && member.post.thumbnailUrl) { %>
                                    <img class='thumbnail' loading='lazy' decoding='async'
                                         alt='@<%- member.postId %>'
                                         src='<%- member.post.thumbnailUrl %>'>
                                <% } else { %>
                                    <span class='thumbnail empty'></span>
                                <% } %>
                                <span class='id'>@<%- member.postId %></span>
                                <span class='distance'>d:<%- member.distance.toFixed(3) %></span>
                            </a>
                        </li>
                    <% } %>
                </ul>
            </div>
        <% } %>
    </div>

    <% if (ctx.total > ctx.limit) { %>
        <nav class='similarity-pager'>
            <% if (ctx.offset > 0) { %>
                <a class='prev' href='<%= ctx.formatClientLink('similarity-scan', ctx.scan.id, { offset: Math.max(0, ctx.offset - ctx.limit) }) %>'>&lang; <%= ctx.t('similarity.prev') %></a>
            <% } else { %>
                <span class='prev disabled'>&lang; <%= ctx.t('similarity.prev') %></span>
            <% } %>
            <span class='page-info'><%= ctx.t('similarity.pageInfo')
                .replace('{from}', ctx.total ? ctx.offset + 1 : 0)
                .replace('{to}', Math.min(ctx.offset + ctx.limit, ctx.total))
                .replace('{total}', ctx.total) %></span>
            <% if (ctx.offset + ctx.limit < ctx.total) { %>
                <a class='next' href='<%= ctx.formatClientLink('similarity-scan', ctx.scan.id, { offset: ctx.offset + ctx.limit }) %>'><%= ctx.t('similarity.next') %> &rang;</a>
            <% } else { %>
                <span class='next disabled'><%= ctx.t('similarity.next') %> &rang;</span>
            <% } %>
        </nav>
    <% } %>
</div>
