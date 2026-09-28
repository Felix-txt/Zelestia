<script>
 let {type="text", placeholder="Placholder", ...props} = $props()
</script>

<input type={type} placeholder={placeholder} {...props}>

<style>
    input{
        background-color: rgb(23, 25, 54);
        border-radius: 24px;
        font-size: large;
        font-weight: bold;
        border: 2px rgb(0, 112, 192) solid;
        padding: 0 24px;
        color: white;
        height: 48px;
        width: 350px;
    }
    input:focus{
        border: 2px rgb(0, 0, 0) solid;
    }
</style>