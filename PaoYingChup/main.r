# Function to determine the winner of the game
determine_winner <- function(computer_choice, user_choice) {
  if (computer_choice == user_choice) {
    return("draw")
  } else if (computer_choice == 1 && user_choice == 3) {
    return("computer")
  } else if (computer_choice == 2 && user_choice == 1) {
    return("computer")
  } else if (computer_choice == 3 && user_choice == 2) {
    return("computer")
  } else {
    return("user")
  }
}

# Main function to play the game
play_game <- function() {
  # Initialize win/loss/draw counts
  user_wins <- 0
  computer_wins <- 0
  draws <- 0

  while (TRUE) {
    # Choose a random option for the computer
    computer_choice <- sample(1:3, 1)

    # Prompt the user for their choice
    print("Enter your choice (1 for rock, 2 for paper, 3 for scissors) or 0 for exit:")
    user_choice <- suppressWarnings(as.numeric(readLines("stdin", n = 1)))

    if (is.na(user_choice)) {
      print("Invalid choice. Please try again.")
      next
    }
    
    # Validate the user's choice
    if (!(user_choice %in% 0:3)) {
      print("Invalid choice. Please try again.")
      next
    }
    
    # Check if the user wants to exit
    if (user_choice == 0) {
      break
    }

    # Determine the winner and update the win/loss/draw counts
    result <- determine_winner(computer_choice, user_choice)
    if (result == "user") {
      user_wins <- user_wins + 1
    } else if (result == "computer") {
      computer_wins <- computer_wins + 1
    } else {
      draws <- draws + 1
    }

    # Print the result
    print(paste("Computer chose", computer_choice))
    print(result)
    print(paste("Wins:", user_wins))
    print(paste("Losses:", computer_wins))
    print(paste("Draws:", draws))
  }
}

# Start the game
play_game()
