<div id='user-summary'>
    <%= ctx.makeThumbnail(ctx.user.avatarUrl) %>
    <ul class='basic-info'>
        <li><%= ctx.t('userSummary.registered') %> <%= ctx.makeRelativeTime(ctx.user.creationTime) %></li>
        <li><%= ctx.t('userSummary.lastSeen') %> <%= ctx.makeRelativeTime(ctx.user.lastLoginTime) %></li>
        <li><%= ctx.t('userSummary.rank') %> <%- ctx.user.rankName.toLowerCase() %></li>
    </ul>

    <div>
        <nav>
            <p><strong><%= ctx.t('userSummary.quickLinks') %></strong></p>
            <ul>
                <li><a href='<%- ctx.formatClientLink('posts', {query: 'submit:' + ctx.user.name}) %>'><%- ctx.user.uploadedPostCount %> <%= ctx.t('userSummary.uploads') %></a></li>
                <li><a href='<%- ctx.formatClientLink('posts', {query: 'fav:' + ctx.user.name}) %>'><%- ctx.user.favoritePostCount %> <%= ctx.t('userSummary.favorites') %></a></li>
                <li><a href='<%- ctx.formatClientLink('posts', {query: 'comment:' + ctx.user.name}) %>'><%- ctx.user.commentCount %> <%= ctx.t('userSummary.comments') %></a></li>
            </ul>
        </nav>

        <% if (ctx.isLoggedIn) { %>
            <nav>
                <p><strong><%= ctx.t('userSummary.onlyVisibleToYou') %></strong></p>
                <ul>
                    <li><a href='<%- ctx.formatClientLink('posts', {query: 'special:liked'}) %>'><%- ctx.user.likedPostCount %> <%= ctx.t('userSummary.likedPosts') %></a></li>
                    <li><a href='<%- ctx.formatClientLink('posts', {query: 'special:disliked'}) %>'><%- ctx.user.dislikedPostCount %> <%= ctx.t('userSummary.dislikedPosts') %></a></li>
                </ul>
            </nav>
        <% } %>
    </div>
</div>
