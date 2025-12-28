const express = require("express");
const { Pool } = require("pg");
require("dotenv").config();

const app = express();
const port = 3000;

const pool = new Pool({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    ssl: false,
});

app.get("/api/ping-db", async (req, res) => {
    try {
        const result = await pool.query("SELECT NOW()");
        res.json({
            status: "ok",
            db: "connected",
            time: result.rows[0].now,
        });
    } catch (err) {
        res.status(500).json({
            status: "error",
            message: err.message,
        });
    }
});

app.listen(port, () => {
    console.log(`Backend running on port ${port}`);
});
