<div class='user-favorite-groups'>
    <form class='new-favorite-group'>
        <input type='text' name='name' placeholder='<%= ctx.t("favGroup.name") %>'>
        <button type='submit'><%= ctx.t('favGroup.create') %></button>
    </form>
    <div class='messages'></div>
    <ul class='fav-group-list'></ul>
</div>
