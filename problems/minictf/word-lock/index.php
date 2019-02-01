<html>
	<?php include("head.html"); ?>

	<body>    
		<form method="post" action="index.php" name="lock">
			<div class="position-relative overflow-hidden p-3 p-md-5 m-md-3 text-center bg-light" style="margin:0px !important; height:300px; background-color:#92a7c4 !important;">
				<div class="col-md-8 p-lg-5 mx-auto my-5" style="padding-top:0px !important; margin-top:0px !important;">
					<h1>Word Lock Vault</h1>
					<p>Welcome to my flag vault - the one and only word lock. Give me the correct three words to open the vault.</p>
					<p>Be warned - we filter for single quotes and OR!</p>
					<div class="form-row" style="padding-bottom: 5px;">
						<div class="col"><input name="word1" type="text" class="form-control" placeholder="Word 1"/></div>
						<div class="col"><input name="word2" type="text" class="form-control" placeholder="Word 2"/></div>
						<div class="col"><input name="word3" type="text" class="form-control" placeholder="Word 3"/></div>
					</div>
					<button type="submit" class="btn btn-secondary">Submit</button>
				</div>
			</div>
		</form>

		<div class="row justify-content-center" style="text-align:center;">
			<div class="col-8">
			<?php
				function cleanInput($s) {
					/* Recursively remove OR from user input */
					$s = strtolower($s);
					$s_curr = preg_replace("/or/", "", $s);
					while ($s !== $s_curr) {
						$s = $s_curr;
						$s_curr = preg_replace("/or/", "", $s);
					}

					/* Recursively remove ' from user input */
					$s_curr = preg_replace("/'/", "", $s);
					while($s !== $s_curr) {
						$s = $s_curr;
						$s_curr = preg_replace("/or/", "", $s);
					}

					return $s;
				}

			   	/* We removed the db connection info - that isn't part of the problem */
				$conn = mysqli_connect("XXX", "XXX", "XXX", "XXX", 1234);

				if (mysqli_connect_errno($conn)) {
					echo "Failed to connect to MySQL: " . mysqli_connect_error();
				} else {
					if (isset($_POST["word1"]) && isset($_POST["word2"]) && isset($_POST["word3"])) {
						$clean_word1 = cleanInput($_POST["word1"]);
						$clean_word2 = cleanInput($_POST["word2"]);
						$clean_word3 = cleanInput($_POST["word3"]);

						$query = "SELECT * FROM flagsafe WHERE word1='" . $clean_word1 . "' AND word2='" . $clean_word2 . "' AND word3='" . $clean_word3 . "'";

						$result = mysqli_query($conn, $query); 

						if ($result) {
							$rowcount = mysqli_num_rows($result);

							if ($rowcount == 0) {
								echo "No flag for you!";
							} else {
								echo '<table class="table table-striped">';
								echo '<thead><tr><th>id</th><th>word1</th><th>word2</th><th>word3</th><th>flag</th></tr></thead>';
								while($value = $result->fetch_array(MYSQLI_ASSOC)){
										echo '<tr>';
										foreach($value as $element){
												echo '<td>' . $element . '</td>';
										}
										echo '</tr>';
								}
								echo '</table>';
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
		</div>
 
	</body>
</html>
