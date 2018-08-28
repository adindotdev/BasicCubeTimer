/*
 * Copyright (C) 2018 Adin Kwok <adin.kwok@carbonrom.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

package com.adinkwok.basiccubetimer;

import java.text.DecimalFormat;
import java.util.ArrayList;

public class TapTimer {
    private boolean mRunning;
    private double mStart;
    private double mEnd;
    private DecimalFormat mDecimalFormatter;
    private ArrayList<Double> mListOfTimes;

    /**
     * Creates a non-running tap timer.
     */
    TapTimer() {
        reset();
        mListOfTimes = new ArrayList<>();
        mDecimalFormatter = new DecimalFormat("0.000");
    }

    /**
     * Taps the timer. Starts the timer if it is not running, else stops the timer and adds the time
     * to mListOfTimes then resets.
     */
    public void tap() {
        if (!mRunning) {
            mStart = System.currentTimeMillis();
            mRunning = true;
            mListOfTimes.add((double) 0);
        } else {
            mEnd = System.currentTimeMillis();
            mListOfTimes.set(mListOfTimes.size() - 1, ((mEnd - mStart) / 1000));
            reset();
        }
    }

    /**
     * Resets the timer.
     */
    public void reset() {
        mRunning = false;
        mStart = 0;
        mEnd = 0;
    }

    public boolean getRunning() {
        return mRunning;
    }

    /**
     * Gets the last time in mListOfTimes. If the timer is running, update the last time.
     *
     * @return the last time.
     */
    public double getTime() {
        if (mRunning) {
            mListOfTimes.set(mListOfTimes.size() - 1, (System.currentTimeMillis() - mStart) / 1000);
        }
        return mListOfTimes.get(mListOfTimes.size() - 1);
    }

    /**
     * Gets the time at the given index of mListOfTimes.
     *
     * @param index the index of mListOfTimes.
     * @return the time at index.
     */
    public double getTime(int index) {
        if (index == mListOfTimes.size() - 1) {
            return getTime();
        }
        return mListOfTimes.get(index);
    }

    /**
     * Gets the last time in mListOfTimes as a String up to 3 decimal places.
     *
     * @return the formatted last time. If mListOfTimes is empty, return a formatted 0.
     */
    public String getFormattedTime() {
        if (mListOfTimes.isEmpty()) {
            return mDecimalFormatter.format(0);
        }
        return mDecimalFormatter.format(getTime(mListOfTimes.size() - 1));
    }

    /**
     * Gets the time at the given index in mListOfTimes as a String up to 3 decimal places.
     *
     * @return the formatted time at the index. If mListOfTimes is empty or no such time at
     * the index exists, return a formatted 0.
     */
    public String getFormattedTime(int index) {
        if (mListOfTimes.isEmpty() || mListOfTimes.size() <= index) {
            return mDecimalFormatter.format(0);
        }
        return mDecimalFormatter.format(getTime(index));
    }
}