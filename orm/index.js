//require packages
const express = require('express');
const cors = require('cors');
const mysql = require('mysql');
//const bodyParser = require('body-parser');
const moment = require('moment');
//var fs = require('fs');
//const https = require('https')

//dealing with mysql issue
//https://stackoverflow.com/questions/50093144/mysql-8-0-client-does-not-support-authentication-protocol-requested-by-server

//basics
//https://www.youtube.com/watch?v=HPIjjFGYSJ4

const app = express();
// call cors
app.use(cors());


//connection for database
var connection = mysql.createConnection({
    host : "localhost",  
    user : "root",
    password : "password",
    database : "platenet",
    insecureAuth : true
});

//test connection
connection.connect(err =>{
    if(!err){
        console.log('db connection success');
    } else {
        console.log(err);
    }
});

//pull records
app.get('/record/:plate',  cors(), function(req,res){
    var plate = req.params.plate;
    console.log(plate)
    var sql = "SELECT Plate, count(*) as Violation_Count FROM platenet.plate_data WHERE plate like '"+plate+"' GROUP BY Plate";
    connection.query(sql, plate, function(err, results) {
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

//add a record 
//https://data-frontiers.info:4500/add?time=${moment().utcOffset('-0500').format("YYYY-MM-DD HH:mm:ss").substr(0, 18) + '0'
//}&lat=${fin.lat}&lon=${fin.lon}&floor=${fin.floor}&poops=${fin.poops}&beer=${fin.beer}&min=${fin.min}&diet=${fin.diet}&shape=${fin.shape}`,
//{ method: "POST" }

app.post('/add', (req, res) => {
    //current_time = moment().utcOffset('-0400').format("YYYY-MM-DD HH:mm:ss").substr(0,18)+'0';
    var my_data = {
        plate: req.query.plate,
        time_stamp: req.query.time
       }
       // now the createStudent is an object you can use in your database insert logic.
       connection.query('INSERT INTO platenet.plates_recorded SET ?', my_data, function (err, results) {
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

