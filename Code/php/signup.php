<?php
    session_start();
    include_once "config.php";
    $first_name = mysqli_real_escape_string($conn, $_POST['first_name']);
    $last_name = mysqli_real_escape_string($conn, $_POST['last_name']);

    $phone_no = mysqli_real_escape_string($conn, $_POST['phone_no']);

    $password = mysqli_real_escape_string($conn, $_POST['password']);


    if(!empty($first_name) && !empty($last_name) && !empty($phone_no) && !empty($password)){


        if(filter_var($phone_no)){


            $sql = mysqli_query($conn, "SELECT * FROM users WHERE phone_no = '{$phone_no}'");


            if(mysqli_num_rows($sql) > 0){
                echo "$phone_no - This phone_no already exist!";
            }else{


                if(isset($_FILES['image'])){
                    $img_name = $_FILES['image']['name'];
                    $img_type = $_FILES['image']['type'];
                    $tmp_name = $_FILES['image']['tmp_name'];

                    
                    $img_explode = explode('.',$img_name);

                    $img_ext = end($img_explode);
    
                    $extensions = ["jpeg", "png", "jpg"];


                    if(in_array($img_ext, $extensions) === true){

                        $types = ["image/jpeg", "image/jpg", "image/png"];


                        if(in_array($img_type, $types) === true){

                            $time = time();

                            $new_img_name = $time.$img_name;

                            if(move_uploaded_file($tmp_name,"images/".$new_img_name)){

                                $ran_id = rand(time(), 100000000);

                                $status = "Active now";

                                $encrypt_pass = md5($password);

                                $insert_query = mysqli_query($conn, "INSERT INTO users (unique_id, first_name, last_name, phone_no, password, img, status)
                                VALUES ({$ran_id}, '{$first_name}','{$last_name}', '{$phone_no}', '{$encrypt_pass}', '{$new_img_name}', '{$status}')");
                                
                                if($insert_query){
                                    $select_sql2 = mysqli_query($conn, "SELECT * FROM users WHERE phone_no = '{$phone_no}'");

                                    if(mysqli_num_rows($select_sql2) > 0){

                                        $result = mysqli_fetch_assoc($select_sql2);

                                        $_SESSION['unique_id'] = $result['unique_id'];
                                        
                                        echo "success";
                                    }else{
                                        echo "This phone_no address not Exist!";
                                    }
                                }else{
                                    echo "Something went wrong. Please try again!";
                                }
                            }
                        }
                        
                        else{
                            echo "Please upload an image file - jpeg, png, jpg";
                            
                        }
                    }else{
                        echo "Please upload an image file - jpeg, png, jpg";
                    }
                }
            }
        }else{
            echo "$phone_no is not a valid phone_no!";
        }
    }else{
        echo "All input fields are required!";
    }
?>