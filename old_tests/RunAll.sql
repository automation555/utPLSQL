set trimspool on
set echo off
set feedback off
set verify off
Clear Screen
set linesize 32767
set pagesize 0
set long 200000000
set longchunksize 1000000
set serveroutput on size unlimited format truncated
@@lib/RunVars.sql

spool RunAll.log

--Global setup
@@helpers/ut_example_tests.pks
@@helpers/ut_example_tests.pkb
--@@helpers/cre_tab_ut_test_table.sql
create table ut$test_table (val varchar2(1));
@@helpers/department.tps
@@helpers/department1.tps
@@helpers/test_package_3.pck
@@helpers/test_package_1.pck
@@helpers/test_package_2.pck
@@helpers/utplsql_test_reporter.typ
@@helpers/test_reporters.pks
@@helpers/test_reporters.pkb
@@helpers/html_coverage_test.pck
@@helpers/test_reporters_1.pks
@@helpers/test_reporters_1.pkb

--Start coverage in develop mode (coverage for utPLSQL framework)
--Regular coverage excludes the framework
exec ut_coverage.coverage_start();
exec ut_coverage.set_develop_mode(true);

@@lib/RunTest.sql ut_suite_manager/ut_suite_manager.get_schema_ut_packages.IncludesPackagesWithSutePath.sql


@@lib/RunTest.sql ut_test/ut_test.OwnerNameInvalid.sql
@@lib/RunTest.sql ut_test/ut_test.OwnerNameNull.sql
@@lib/RunTest.sql ut_test/ut_test.PackageInInvalidState.sql
@@lib/RunTest.sql ut_test/ut_test.PackageNameInvalid.sql
@@lib/RunTest.sql ut_test/ut_test.PackageNameNull.sql
@@lib/RunTest.sql ut_test/ut_test.ProcedureNameInvalid.sql
@@lib/RunTest.sql ut_test/ut_test.ProcedureNameNull.sql
@@lib/RunTest.sql ut_test/ut_test.SetupExecutedBeforeTest.sql
@@lib/RunTest.sql ut_test/ut_test.SetupProcedureNameInvalid.sql
@@lib/RunTest.sql ut_test/ut_test.SetupProcedureNameNull.sql
@@lib/RunTest.sql ut_test/ut_test.TeardownExecutedAfterTest.sql
@@lib/RunTest.sql ut_test/ut_test.TeardownProcedureNameInvalid.sql
@@lib/RunTest.sql ut_test/ut_test.TeardownProcedureNameNull.sql
@@lib/RunTest.sql ut_test/ut_test.IgnoreTollbackToSavepointException.sql
@@lib/RunTest.sql ut_test/ut_test.AfterEachExecuted.sql
@@lib/RunTest.sql ut_test/ut_test.AfterEachProcedureNameInvalid.sql
@@lib/RunTest.sql ut_test/ut_test.AfterEachProcedureNameNull.sql
@@lib/RunTest.sql ut_test/ut_test.BeforeEachExecuted.sql
@@lib/RunTest.sql ut_test/ut_test.BeforeEachProcedureNameInvalid.sql
@@lib/RunTest.sql ut_test/ut_test.BeforeEachProcedureNameNull.sql
@@lib/RunTest.sql ut_test/ut_test.TestOutputGathering.sql
@@lib/RunTest.sql ut_test/ut_test.TestOutputGatheringWhenEmpty.sql
@@lib/RunTest.sql ut_test/ut_test.ReportWarningOnRollbackFailed.sql
@@lib/RunTest.sql ut_test/ut_test.ApplicationInfoOnExecution.sql

--Finally
@@lib/RunSummary

spool off

--Global cleanup
--removing objects that should not be part of coverage report
drop package ut_example_tests;
drop table ut$test_table;
drop type department$;
drop type department1$;
drop package test_package_1;
drop package test_package_2;
drop package test_package_3;
drop type utplsql_test_reporter;
drop package test_reporters;
drop package ut3$user#.html_coverage_test;

--can be used by CI to check for tests status
exit :failures_count
