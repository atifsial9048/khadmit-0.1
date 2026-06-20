// Temporary mock functions - production ke liye real API later
export const signup = async (userData) => {
  console.log('Signup called with:', userData);
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve({ 
        success: true, 
        user: { ...userData, id: Date.now().toString() } 
      });
    }, 1000);
  });
};

export const signin = async (credentials) => {
  console.log('Signin called with:', credentials);
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve({ 
        success: true, 
        user: { name: 'Test User', email: credentials.email } 
      });
    }, 1000);
  });
};

export const signout = async () => {
  console.log('Signout called');
  return { success: true };
};
