package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

const (
	bucketPrefix string = "tom-test-bucket-12341234"
	env string = "terratest"
	awsRegion string = "eu-west-2"
)

func TestTerraformS3(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"env":      "terratest",
			"region":   "eu-west-2",
			"role_arn": "arn:aws:iam::637180932514:role/orion/orion-admin-user",
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": "eu-west-2",
		},
	}

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	bucketID := terraform.Output(t, terraformOptions, "bucket_id")
	assert.Equal(t, fmt.Sprintf("%s-%s", bucketPrefix, env), bucketID)

	// Verify that our Bucket has versioning enabled
	actualStatus := aws.GetS3BucketVersioning(t, awsRegion, bucketID)
	expectedStatus := "Disabled"
	assert.Equal(t, expectedStatus, actualStatus)

	// Verify that our Bucket has a policy attached
	aws.AssertS3BucketPolicyExists(t, awsRegion, bucketID)
}
