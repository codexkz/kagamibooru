<p><%= ctx.t('help.comments.intro') %></p>

<table>
    <tbody>
        <tr>
            <td><code>@426</code></td>
            <td><%= ctx.t('help.comments.linkPost') %></td>
        </tr>
        <tr>
            <td><code>#Dragon_Ball</code></td>
            <td><%= ctx.t('help.comments.linkTag') %></td>
        </tr>
        <tr>
            <td><code>+Pirate</code></td>
            <td><%= ctx.t('help.comments.linkUser') %></td>
        </tr>
        <tr>
            <td><code>~~new~~</code></td>
            <td><%= ctx.t('help.comments.strikethrough') %></td>
        </tr>
        <tr>
            <td><code>[spoiler]Lelouch survives[/spoiler]</td>
            <td><%= ctx.t('help.comments.spoiler') %></td>
        </tr>
        <tr>
            <td><code>[sjis](´･ω･`)[/sjis]</td>
            <td><%= ctx.t('help.comments.sjis') %></td>
        </tr>
        <tr>
            <td><code>[icon]https://youtube.com[/icon]</td>
            <td><%= ctx.t('help.comments.siteIcon') %></td>
        </tr>
    </tbody>
</table>

<p><%= ctx.t('help.comments.imageSize') %></p>

<ul>
<li><code>![alt](href =WIDTHx "title")</code></li>
<li><code>![alt](href =xHEIGHT "title")</code></li>
<li><code>![alt](href =WIDTHxHEIGHT "title")</code></li>
</ul>
