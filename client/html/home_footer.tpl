<ul>
    <li><%- ctx.postCount %> <%= ctx.t('home.postCount', '').split('{count}')[1] || 'posts' %></li><span class='sep'>
    </span><li><%= ctx.makeFileSize(ctx.diskUsage) %></li><span class='sep'>
    </span><li>Build <a class='version' href='https://github.com/codexkz/kagamibooru/commits/master'><%- ctx.version %></a><%- ctx.isDevelopmentMode ? " (DEV MODE)" : "" %> from <%= ctx.makeRelativeTime(ctx.buildDate) %></li><span class='sep'>
    </span><% if (ctx.canListSnapshots) { %><li><a href='<%- ctx.formatClientLink('history') %>'><%= ctx.t('home.history') %></a></li><span class='sep'>
    </span><% } %>
</ul>
