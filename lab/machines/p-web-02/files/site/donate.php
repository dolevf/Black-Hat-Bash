<html>
<body>
<h1>Welcome to ACME Hyper Alliance Donation Page.<h1>
<h2>We appreciate any donations made towards our cause of saving cats. <h2>
<form method="GET" name="<?php echo basename($_SERVER['PHP_SELF']); ?>">
<input type="TEXT" name="amount" autofocus id="amount" size="80">
<input type="SUBMIT" value="donate">
</form>

<pre>
<?php
    if(isset($_GET['amount']))
    {
        if (str_contains($_GET['amount'], ";")) { 
            echo "Character ; is not allowed"; 
            exit();
        }
        system("echo " . $_GET['amount'] . " >> amount_to_donate.txt");
        echo "OK! your amount " . $_GET['amount'] . " will be donated to our cause. Thanks!";
    } 
?>
</pre>
</body>
</html>