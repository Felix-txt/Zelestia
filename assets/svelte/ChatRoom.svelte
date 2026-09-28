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

<div class="field flex flex-col justify-between items-between min-h-[400px]">
    <ul class="messages flex flex-col gap-2">
        {#each messages as message (message.id)}
            <li in:slide class="bg-[#eee] rounded-full px-4 py-2 rounded-bl-none">
                <i>{message.name}:</i>
                {message.body}
            </li>
        {/each}
    </ul>

    

    <form class="message_field" onsubmit={preventDefault(submitMessage)}>
        <input type="text" name="name" class="rounded" bind:value={name} placeholder="Your Name"  autocomplete="off"/>
        <input type="text" name="message" class="rounded" bind:value={message} placeholder="Message..." autocomplete="off" />
        <button class="bg-black text-white rounded px-4 py-2">Send</button>
    </form>
</div>

<style>

.field{
    overflow: hidden;
    display: flex;
    flex-direction: column;
    scroll-behavior: none;
}

.message_field{
    display: grid;
    grid-template-columns: 10% 80% 10%;
    justify-content: center;
    border: 6px solid var(--theme-border);
    border-radius: 16px;
    background: var(--theme-middle-background);
}

.messages{
    height: auto;
    max-height: 800px;
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

</style>