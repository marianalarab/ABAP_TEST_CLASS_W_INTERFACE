# Abap Test class using interface to simulate DB access

<p>This program was developed in Sep/2023<br />SAP version: ECC 6.0<br />HANA Database</p>
<ul>
<li>ZUPD_SO_PRICING.abap -&gt; Is the main class</li>
<li>ZUPD_SO_PRICING_DAO.abap -&gt; Is needed so the test class can work without accessing de actual database and run its unit tests with coverage.</li>
<li>lcl_zupd_so_pricing_dao.abap -&gt; Is the local implementation of the DAO class that simulates de access to the database</li>
<li>LCL_ZUPD_SO_PRICING.abap -&gt; Is the Unit Test Class</li>
<li>ZUPD_IF_SO_PRICING.abap -&gt; Interface for DB access Methods.</li>
</ul>
