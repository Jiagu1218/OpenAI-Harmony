/**
 *
 * @export
* @interface CreateModerationRequest
 */
export interface CreateModerationRequest {
  /**
   *
   * @type {CreateModerationRequestInput}
   * @memberof CreateModerationRequest
   */
  'input': CreateModerationRequestInput;
  /**
   * Two content moderations models are available: `text-moderation-stable` and `text-moderation-latest`.  The default is `text-moderation-latest` which will be automatically upgraded over time. This ensures you are always using our most accurate model. If you use `text-moderation-stable`, we will provide advanced notice before updating the model. Accuracy of `text-moderation-stable` may be slightly lower than for `text-moderation-latest`.
   * @type {string}
   * @memberof CreateModerationRequest
   */
  'model'?: string;
}
/**
 * @type CreateModerationRequestInput
 * The input text to classify
 * @export
 */
export declare type CreateModerationRequestInput = Array<string> | string;