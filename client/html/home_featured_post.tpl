<div class='post-container'></div>
<% if (ctx.featuredPost) { %>
    <aside>
        <%= ctx.t('home.featuredPost') %>&nbsp;<%= ctx.makePostLink(ctx.featuredPost.id, true) %>,<wbr>
        &nbsp;<%= ctx.makeRelativeTime(ctx.featuredPost.creationTime) %>&nbsp;&nbsp;<%= ctx.makeUserLink(ctx.featuredPost.user) %>
    </aside>
<% } %>
