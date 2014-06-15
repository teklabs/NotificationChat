//
// Copyright (c) 2014 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Parse/Parse.h>
#import "ProgressHUD.h"

#import "AppConstant.h"

#import "LoginView.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface LoginView()

@property (strong, nonatomic) IBOutlet UITableViewCell *cellUsername;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellPassword;

@property (strong, nonatomic) IBOutlet UITextField *fieldUsername;
@property (strong, nonatomic) IBOutlet UITextField *fieldPassword;

@property (strong, nonatomic) IBOutlet UIView *viewButton;
@property (strong, nonatomic) IBOutlet UIButton *buttonLogin;

@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation LoginView

@synthesize cellUsername, cellPassword;
@synthesize fieldUsername, fieldPassword;
@synthesize viewButton, buttonLogin;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
	self.title = @"Login";
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.tableView.tableFooterView = viewButton;
	self.tableView.separatorInset = UIEdgeInsetsZero;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	buttonLogin.backgroundColor = HEXCOLOR(0x205081ff);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidAppear:animated];
	[fieldUsername becomeFirstResponder];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)dismissKeyboard
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self.view endEditing:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)actionLogin:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *username = fieldUsername.text;
	NSString *password = fieldPassword.text;

	if ((username.length != 0) && (password.length != 0))
	{
		[ProgressHUD show:@"Signing in..." Interaction:NO];
		[PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error)
		{
			if (user != nil)
			{
				[ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome back %@!", [user objectForKey:PF_USER_USERNAME]]];
				[self dismissViewControllerAnimated:YES completion:nil];
			}
			else [ProgressHUD showError:@"Login failed. Please try again."];
		}];
	}
	else [ProgressHUD showError:@"Please enter both username and password."];
}

#pragma mark - Table view data source

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 1;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 2;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 64.0;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (indexPath.row == 0) return cellUsername;
	if (indexPath.row == 1) return cellPassword;
	return nil;
}

#pragma mark - UITextField delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (textField == fieldUsername)
	{
		[fieldPassword becomeFirstResponder];
	}
	if (textField == fieldPassword)
	{
		[self actionLogin:nil];
	}
	return YES;
}

@end
