<html>
  <?php include("head.html"); ?>

  <body>
    <?php include("navbar.html"); ?>
    
    <form method="post" action="search.php" name="search">
      <div class="position-relative overflow-hidden p-3 p-md-5 m-md-3 text-center bg-light" style="background: url('bagel_30.jpg') no-repeat -500px -100px; margin:0px !important; height:300px;">
				<div class="col-md-8 p-lg-5 mx-auto my-5">
	  			<h1 style="color:white;">Bagel Inventory Search</h1>
	  			<input name="bagel" type="text" class="form-control" placeholder="Check if a bagel is available!"/>
				</div>
      </div>
    </form>

    <div class="row justify-content-center">
			<?php
				/* We removed the db connection info - this isn't part of the problem */
				$conn = mysqli_connect("XXX", "XXX", "XXX", "XXX");
		
				if (mysqli_connect_errno($conn)) {
					echo "Failed to connect to MySQL: " . mysqli_connect_error();
				} else {
					/* When user searches inventory, a POST request is made - check it out in the 
					 * developer tools network tab! */
					if (isset($_POST["bagel"])) {
						
						/* Here is the database query to make */
						$query = "SELECT type,description FROM bagels WHERE type='" . $_POST["bagel"] . "'";

						$result = mysqli_query($conn, $query);

						if ($result) {
							$rowcount = mysqli_num_rows($result);
							if ($rowcount == 0) {
								echo "Sorry we don't seem to have those bagels... :(";
							} else if ($rowcount == 1) {
								echo $rowcount . " bagel found!";
							} else {
								echo $rowcount . " bagels found!";
							}
							$result->close();
						} else {
							echo "SQL query syntax error.";
						}
			
						mysqli_close($conn);
					}
				}	
			?>
    </div>
 
  </body>
</html>
