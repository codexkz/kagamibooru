<% if (ctx.canFavorite) { %>
    <% if (ctx.ownFavorite) { %>
        <a href class='remove-favorite'>
            <i class='fa fa-star'></i>
    <% } else { %>
        <a href class='add-favorite'>
            <i class='fa fa-star-o'></i>
    <% } %>
<% } else { %>
    <a class='add-favorite inactive'>
        <i class='fa fa-star-o'></i>
<% } %>
    <span class='vim-nav-hint'><%= ctx.t('fav.add') %></span>
</a>
<span class='value'><%- ctx.favoriteCount %></span>
<% if (ctx.canManageGroups) { %>
    <a href class='manage-fav-groups' title='<%= ctx.t("favGroup.manageTooltip") %>'>
        <i class='fa fa-folder-o'></i>
    </a>
<% } %>
