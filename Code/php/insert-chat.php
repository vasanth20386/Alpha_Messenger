<?php 
    session_start();
    if(isset($_SESSION['unique_id'])){


        include_once "config.php";
        $outgoing_id = $_SESSION['unique_id'];
        
        $incoming_id = mysqli_real_escape_string($conn, $_POST['incoming_id']);

        $message = mysqli_real_escape_string($conn, $_POST['message']);


        if(!empty($message)){

            
            $sql = mysqli_query($conn, "INSERT INTO messages (reciever_id, sender_id, msg_body)
                                        VALUES ({$incoming_id}, {$outgoing_id}, '{$message}')") or die();
        }
    }else{
        header("location: ../login.php");
    }
    
?>





