const cors = require('cors');
const express = require('express');
const mysql = require('mysql');

//dealing with mysql issue
//https://stackoverflow.com/questions/50093144/mysql-8-0-client-does-not-support-authentication-protocol-requested-by-server

//basics
//https://www.youtube.com/watch?v=HPIjjFGYSJ4

//pooled
//https://medium.com/@carloscuba014/building-a-react-app-that-connects-to-mysql-via-nodejs-using-docker-a8acbb0e9788

const app = express();
// call cors
app.use(cors()); //attempting disable for caddy 

//original connection test
var con = mysql.createConnection({
    host: "mysql",
    user: "root",
    password: "password",
    database : "platenet",
    insecureAuth : true
  });

  con.connect(function(err) {
    if (err) throw err;
    console.log("Connected!");
  });

//connection for database
const pool = mysql.createPool({
    host : "mysql",  
    user : "root",
    password : "password",
    database : "platenet",
    insecureAuth : true
  });

//test generic serve access
app.get('/', (req, res) => res.send('wassup!'))

//test generic server endpoint access
app.get('/hello', (req, res) => res.send('wassup bro!'))

//test records from myql
app.get('/test',  function(req,res){
    var plate = req.params.plate;
    console.log(plate)
    console.log('attempting connection')
    var sql = "SELECT * FROM platenet.plate_data_stg LIMIT 5";
    pool.query(sql, plate, function(err, results) {
        if(err) {
            return res.send(err)
        } else {
            console.log(results)
            return res.json({
                data: results
            })
        }
    });
});

//pull records
app.get('/record/:plate', function(req,res){
    var plate = req.params.plate;
    console.log(plate)
    var sql = "SELECT * FROM platenet.plate_data_prd WHERE plate like '"+plate+"'";
    pool.query(sql, plate, function(err, results) {
        if(err) {
            return res.send(err)
        } else {
            console.log(results)
            return res.json({
                data: results
            })
        }
    });
});


app.post('/add', (req, res) => {
    //current_time = moment().utcOffset('-0400').format("YYYY-MM-DD HH:mm:ss").substr(0,18)+'0';
    var my_data = {
        plate: req.query.plate,
        time_stamp: req.query.time
       }
       // now the createStudent is an object you can use in your database insert logic.
       pool.query('INSERT INTO platenet.plates_recorded SET ?', my_data, function (err, results) {
        if(err) {
            console.log(err)
            return res.send(err)
            
        } else {
            console.log(results)
            return res.json({
                data: results
            })
        }
    });
});


//set server to listen 
app.listen(3001,()=>console.log('Express Server is Running on port 3001'));

