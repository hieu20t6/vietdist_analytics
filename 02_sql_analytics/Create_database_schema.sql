-- Tạo database vietdist_dw
CREATE DATABASE vietdist_dw; 

 -- Tạo 3 SCHEMA 
CREATE SCHEMA raw;      -- Bronze layer 
CREATE SCHEMA staging;  -- Silver layer 
CREATE SCHEMA dwh;      -- Gold layer 