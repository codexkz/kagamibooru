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

    <div class='messages'></div>

    <% if (!ctx.groups.length) { %>
        <p class='no-results'><%= ctx.t('similarity.noGroups') %></p>
    <% } %>

    <div class='groups'>
        <% for (let [index, group] of ctx.groups.entries()) { %>
            <div class='group' data-group-id='<%= group.id %>'>
                <h2><%= ctx.t('similarity.group').replace('{n}', index + 1) %>
                    <span class='count'>(<%- group.members.length %>)</span>
                </h2>
                <ul class='thumbs'>
                    <% for (let member of group.members) { %>
                        <li>
                            <a class='thumbnail-wrapper'
                               target='_blank'
                               href='<%= ctx.formatClientLink('post', member.postId) %>'>
                                <%= ctx.makeThumbnail(member.post ? member.post.thumbnailUrl : null) %>
                                <span class='id'>@<%- member.postId %></span>
                                <span class='distance'>d:<%- member.distance.toFixed(3) %></span>
                            </a>
                        </li>
                    <% } %>
                </ul>
            </div>
        <% } %>
    </div>
</div>
