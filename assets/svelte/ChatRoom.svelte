<script>
    import {preventDefault} from "svelte/legacy"

    import {slide} from "svelte/transition"

    /** @type {{messages: any, live: any}} */
    let {messages, live} = $props()

    let message = $state("")
    let name = $state("")

    function submitMessage() {
        if (message === "" || name === "") return
        live.pushEvent("send_message", {body: message, name: name})
        message = ""
    }
</script>

<div class="field">
    <ul class="messages">
        {#each messages as message (message.id)}
            <li in:slide class="">
                <i>{message.name}:</i>
                <br>
                {message.body}
            </li>
        {/each}
    </ul>

    
    <form class="message_field" onsubmit={preventDefault(submitMessage)}>
        <input type="text" name="name" class="rounded" bind:value={name} placeholder="Your Name"  autocomplete="off"/>
        <input type="text" name="message" class="rounded" bind:value={message} placeholder="Message..." autocomplete="off" />
        <button class="rounded">Send</button>
    </form>
</div>

<style>

.field{
    display: grid;
    height: 100%;
    grid-template-rows: 90% auto;
    overflow: hidden;
    scroll-behavior: none;
}

.message_field{
    display: grid;
    grid-template-columns: 10% 80% 10%;
    justify-content: center;
    max-height: 30px;
    border: 8px solid var(--theme-border);
    border-radius: 25px;
    background: var(--theme-middle-background);
}

.messages{
    height: 800px;
    overflow: scroll;
    scroll-behavior: smooth;
}

.messages > li{
    word-wrap: break-word;
    list-style-type: none;
    font-weight: bold;
    font-size: large;
    color: var(--theme-foreground);
}

.rounded{
    word-wrap: break-word;
    background: var(--theme-border); /* input background */
    color: var(--theme-accent);/* text colour */
    border: none;
}

.message_field > button:hover{
    cursor: pointer;
}

</style>