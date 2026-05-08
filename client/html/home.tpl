<div class='content-wrapper transparent' id='home'>
    <div class='messages'></div>
    <header>
        <h1><%- ctx.name %></h1>
    </header>
    <% if (ctx.canListPosts) { %>
        <form class='horizontal'>
            <%= ctx.makeTextInput({name: 'search-text', placeholder: ctx.t('home.searchPlaceholder')}) %>
            <input type='submit' value='<%= ctx.t("home.search") %>'/>
            <span class=sep><%= ctx.t('home.or') %></span>
            <a href='<%- ctx.formatClientLink('posts') %>'><%= ctx.t('home.browseAll') %></a>
        </form>
    <% } %>
    <div class='post-info-container'></div>
    <footer class='footer-container'></footer>
</div>
