<div class='not-found'>
    <h1><%= ctx.t('notFound.title') %></h1>
    <p><%- ctx.path %> <%= ctx.t('notFound.notValidUrl') %></p>
    <p><a href='<%- ctx.formatClientLink() %>'><%= ctx.t('notFound.backToMain') %></a></p>
</div>
