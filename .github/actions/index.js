const core = require('@actions/core');
const github = require('@actions/github');

try {
  const myInput = core.getInput('my-input');
  console.log(`My input is ${myInput}`);

  const myOutput = `Processed ${myInput}`;
  core.setOutput('my-output', myOutput);
} catch (error) {
  core.setFailed(error.message);
}
