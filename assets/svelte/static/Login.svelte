<script>
    import AccountInput from "../components/account/AccountInput.svelte"
    import AccountForm from "../components/account/AccountForm.svelte"
    import AccountButton from "../components/account/AccountButton.svelte"
    let { csrf_token } = $props(); 
</script>

<div class="container">
    <AccountForm 
        csrf_token={csrf_token} 
        method="post", 
        action=""
        formName="Login"
        >
        <div class="form">
            <h1>
                Login
            </h1>
            <div class="inputs">
                <AccountInput 
                    type="text" 
                    placeholder="Username" 
                    name="username" 
                    autocomplete="off"
                    required
                />
                <AccountInput 
                    type="password" 
                    placeholder="Password" 
                    name="password" 
                    autocomplete="off"
                    required
                />
                <div class="other">
                    <div class="account">
                        <span>No Account?</span>
                        <a href="/account/create"><span>Register</span></a>
                    </div>
                    <AccountButton value="Login" /> 
                </div>
            </div>
        </div>
    </AccountForm>
</div>

<style>
    h1{
        font-weight: bold;
        color: white;
        grid-area: title;
        text-align: center;
    }

    .account{
        display: flex;
        gap: 8px;
        color: white;
        font-weight: bold;
    }
    .account a{
        color: white;
        font-weight: bold;
    }
    .account a:hover{
        color: rgb(255, 0, 0);
    }
    .account a:active{
        color: rgb(102, 11, 11);
    }
    .account a:visited{
        color: rgb(146, 146, 146);
    }

    .form{
        display: grid;
        width: 100%;
        height: 100%;
        grid-template-areas: 
            "title  title  title"
            "inputs  inputs  inputs"
            "inputs  inputs  inputs";
        /* grid-template-rows: 1fr 5fr 5fr; */
            
    }
    .other{
        width: 100%;
        display: flex;
        flex-direction: row;
        align-items: center;
        justify-content: space-between;
    }

    .inputs{
        grid-area: inputs;
        display: flex;
        flex-direction: column;
        gap: 16px;
        align-items: center;
        margin: 0px auto;
        width:min-content;
    }

    .container{
        display: flex;
        justify-content: center;
        align-items: center;
        position: absolute;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        
    }
</style>